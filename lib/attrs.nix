{ lib, ... }:

with lib; {
  # mapFilterAttrs ::
  #   (name -> value -> bool)
  #   (name -> value -> { name = any; value = any; })
  #   attrs -> attrs
  #
  # Maps an attrset with a renaming/transforming function, then filters the result by a predicate.
  mapFilterAttrs = pred: f: attrs: filterAttrs pred (mapAttrs' f attrs);
}
