---
name: webgl-shaders
description: Practitioner guide to WebGL and GLSL shader work on the web — choosing between three.js, OGL and react-three-fiber, writing vertex/fragment shaders, the effects that actually appear on award-winning sites (displacement, fluid, particle fields, text distortion, gradient meshes), and the performance, fallback and accessibility rules that keep them shippable. Use when the user asks for a shader, a canvas effect, three.js work, a WebGL hero, hover displacement, a particle system, or "make this feel expensive" with motion on a surface. Implementation only — whether the effect belongs in the design at all is decided by no-slop, taste, emil-design-eng and motion-sensitivity.
---

# WebGL & shaders

> **Read the project's `package.json` before writing code from this skill.**
> It assumes `three` (or `ogl` / `@react-three/fiber`) is a dependency, which often is not the case. If missing:
> name it, give the cost, and **ask** before installing - never `npm install`
> silently, and never hand-build an approximation of it instead.
> Confirm which renderer the project already has before writing against a different one; mixing three.js and OGL in one page is pure weight.

**Implementation only.** Whether a canvas effect belongs on the page is a direction
call owned by `taste`, `no-slop` and `emil-design-eng`. Where they say no, this skill
is silent. Never propose a shader as the answer to "what should this look like".

## Decide whether it earns its place first

A WebGL hero costs a bundle, a battery, a fallback path, and an accessibility story.
It earns that when the effect *is* the idea — a material, a physical metaphor, a piece
of data made tactile. It does not earn it as ambience behind a headline; that is a
gradient with extra steps, and `no-slop` treats it as decoration.

Ask: if this were a static image, what would be lost? If the honest answer is
"nothing", build the static image.

## Stack

| Need | Use | Why |
|---|---|---|
| One effect on one surface | **OGL** or raw WebGL | ~8kb. three.js for a single quad is 600kb of scene graph you never use |
| A scene, camera, lights, models | **three.js** | The default. Worth its weight once geometry and cameras are real |
| React / Next.js app | **react-three-fiber** + `@react-three/drei` | Declarative, plays well with React state. `drei` has the helpers you'd otherwise rewrite |
| Post-processing chain | `postprocessing` (pmndrs) | Merges passes into one render; the naive EffectComposer path is slower |

In Next.js, canvas components are client-only: `dynamic(() => import('./Scene'), { ssr: false })`.
`window`, `document` and `WebGLRenderingContext` do not exist during SSR.

## Shader fundamentals

A **vertex** shader runs per vertex and outputs `gl_Position` — it moves geometry.
A **fragment** shader runs per pixel and outputs a color — it paints. Data flows
vertex → fragment through `varying` (GLSL ES 1.0) or `out`/`in` (GLSL ES 3.0).

Standard uniform set for almost any effect:

```glsl
uniform float uTime;        // seconds, advanced from the render loop
uniform vec2  uResolution;  // canvas size in device px
uniform vec2  uMouse;       // normalised 0..1, lerped — never raw
uniform float uProgress;    // 0..1 for scroll or state-driven effects
uniform sampler2D uTexture; // the image, video, or rendered text
```

Normalise coordinates and correct for aspect, or every effect stretches on resize:

```glsl
vec2 uv = gl_FragCoord.xy / uResolution;
uv.x *= uResolution.x / uResolution.y;
```

**Always lerp the mouse.** Raw pointer values make effects feel twitchy and cheap;
`uMouse += (target - uMouse) * 0.08` per frame is the difference between "expensive"
and "jittery".

## The effects that actually ship

- **Hover displacement on an image** — sample a noise or gradient texture, offset the image UV by it, drive the amount with a lerped hover value. The single highest ratio of perceived craft to code on the web.
- **RGB shift / chromatic aberration** — sample the texture three times at slightly offset UVs into `.r`, `.g`, `.b`. Keep it under ~4px or it reads as a broken monitor.
- **Fluid / ripple** — a ping-pong framebuffer holding velocity, advected each frame, with the pointer injecting force. Two render targets swapped per frame.
- **Particle fields** — one `Points` object with a custom vertex shader. Positions in a buffer attribute, animated in the shader, never on the CPU. 100k points is fine; 100k draw calls is not.
- **Text distortion** — render text to a texture (canvas 2D or an MSDF atlas) and displace it. Do **not** try to shape glyphs in GLSL.
- **Gradient mesh / aurora** — layered simplex noise in a fragment shader, remapped into two or three brand colors. The one case where "ambience" can be defensible, because it replaces an image entirely.

## Scroll-reactive image warp — the field-tested recipe

Won the hard way on a scroll-driven plate warp: six wrong versions, then a measured
one. What generalises is here.

**Architecture.** ONE fixed full-viewport canvas, orthographic camera, one textured
plane per DOM image, re-positioned every frame from `getBoundingClientRect()`. CSS
hides the source `<img>`'s parent only while the canvas is live, so JS-off and
reduced-motion render the finished page, not a blank.

**The drive chain** (smooth-scroll velocity → shader strength):

- **Lenis `velocity` is px per FRAME, not px/s** — verified v=86 against an 86px step.
- Chain: clamp velocity → gain → `drive` lerped toward it each frame → target decays
  (`*= ~0.965`) so rest returns to exactly 0. Hysteresis (separate on/off thresholds
  plus quiet-frames) stops flicker at the boundary.
- **Calibrate against a recording of the real hand, never synthetic wheel events.**
  Synthetic dispatch produced 300-500px/frame; the actual human median was 24. A gain
  tuned on synthetic input saturates on every real scroll and reads as broken.
- A wave can be anchored to the SCREEN (viewport-space `sin`, phase drifting with
  time) or to the PAGE. They look identical in stills; a two-speed measurement
  (bend px/s vs page px/s) separates them in one experiment.

**Six traps, each of which shipped a broken build before being named:**

- **A backtick inside a GLSL template literal ends the string silently.** After any
  shader edit, assert: no backtick in the extracted body, `void main` present,
  braces balanced. It hit twice; the gate is three lines.
- **Never hand a live `next/image` (or any srcset) `<img>` to a texture.** The
  browser swaps its bitmap on resize and the GPU upload overflows
  (`glTexSubImage2D... Offset overflows`). Snapshot the image to a canvas once and
  texture from that.
- **Verify the COMPOSITE, not the canvas.** Reading the WebGL canvas alone inspects
  a layer nobody sees; z-index, blend and the CSS hide/show can all be wrong above
  it. The screenshot that counts is the viewport mid-interaction. Same family:
  `getComputedStyle(img).opacity` reads "1" while a PARENT is at 0 — probe the
  element the CSS actually touches.
- **`smoothstep(a, b, x)` requires `a < b`.** Reversed edges are undefined in GLSL,
  and at least one desktop GPU path resolves them to 0 with no error, so a mask
  written backwards never fires and nothing says so. Write `1.0 - smoothstep(b, a, x)`
  for a descending mask.
- **A closed spline over an angular index draws a chord.** Catmull-Rom on
  `(index, radius)` for a polar outline wraps its last segment from N-1 back to 0
  THROUGH THE CENTRE. The contour self-intersects, the triangulator papers over it
  with overlapping triangles, and anything surface-sensitive (shell fur, relief)
  shows the overlap as a rim-to-rim seam. Advance the angle linearly; spline only
  the radius. Gate: cap triangles = points - 2, and summed triangle area = polygon
  area, to the fifth decimal.
- **Zero-length shells z-fight.** In shell fur, a face whose fibre length is 0
  stacks every shell on one surface, and the depth fight paints flat triangular
  patches in different shades. Either every face carries length, or shells above
  the first are discarded where it is 0.

Process for tuning any of this: `measure-first`. Scale-invariant numbers (bow as %
of the plate's own width), zero-control every instrument, and the reference's
figure measured with the same tool as yours.

## Performance

The frame budget is **16.7ms at 60fps**, and on a 120Hz display users feel 8.3ms.

- **Clamp pixel ratio:** `renderer.setPixelRatio(Math.min(devicePixelRatio, 2))`. Retina at 3× quadruples fragment work for no visible gain.
- **Fragment shaders are per-pixel.** A full-screen effect at 1440p runs your `main()` ~3.7M times per frame. Move everything you can to the vertex shader or a uniform.
- **Instancing over objects.** `InstancedMesh` for repeated geometry; one draw call instead of N.
- **Texture size is memory.** Resize to the largest size actually displayed, use KTX2/Basis for large scenes, and mind that a 4096² RGBA texture is 64MB uncompressed.
- **Pause offscreen.** An `IntersectionObserver` that stops the RAF loop when the canvas leaves the viewport is the cheapest win available.
- **One rAF for the page, not one per library.** A canvas alongside Lenis and GSAP is
  three independent loops; whoever registers last reads a stale value that frame. Drive
  all three from a single loop with an explicit order — scroll, then tweens, then render.
  Wiring, and when `tempus` is worth the dependency, in `gsap-web` ("Three loops or more").
- **Dispose on unmount.** Geometries, materials, textures and render targets all leak otherwise; in React, dispose in the effect cleanup.
- Profile with Spector.js for draw calls, and the browser's frame timeline for the actual budget.

## Fallbacks and accessibility — non-negotiable

Pair with `motion-sensitivity`; it wins on any conflict.

- **`prefers-reduced-motion: reduce`** → render one static frame, or swap to a poster image. Do not simply slow the animation down.
- **No WebGL context** (blocked, old GPU, headless) → detect with `canvas.getContext('webgl2') ?? canvas.getContext('webgl')` and render the static fallback. Never leave a blank rectangle.
- **Never put content inside the canvas.** A canvas is invisible to screen readers, unselectable, and unindexable. Real text sits in the DOM above it; the canvas is decoration with `aria-hidden="true"`.
- **Battery and thermals.** On mobile, drop pixel ratio and consider capping to 30fps — a phone that gets hot is a worse experience than a simpler effect.

## Where this hands off

- Scroll-driven shader progress → `gsap-web` (ScrollTrigger drives `uProgress`)
- Frame budget and layout thrash → `60fps-animation`
- Whether to animate at all → `emil-design-eng`
- Reduced motion and vestibular safety → `motion-sensitivity` (always)
- Measured verification of the built result → `craft-floor`
