# taste/

Your taste library. It ships empty on purpose: this is the one part of the kit
that cannot be inherited, because it is a record of what *you* respond to.

- `TASTE.md` is the synthesised profile. It does not exist yet. Run
  `/taste-sync` once there are entries to synthesise from.
- `library/` holds one markdown file per saved reference, tagged.

Add the first entry with `/taste-add`, or point the `taste` skill at a link and
let it file the entry for you.

Until there is something here, the `taste` skill is required to SAY the library
is empty rather than invent preferences on your behalf. An empty library is a
fact about the setup, not a gap to fill with guesses.
