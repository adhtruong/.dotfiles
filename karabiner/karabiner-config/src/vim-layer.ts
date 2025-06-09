import { map } from "karabiner.ts";
import { createLayer } from "./utils";

export function createVimLayer() {
  return [
    createLayer("s").manipulators([
      map("j").to("down_arrow"),
      map("h").to("left_arrow"),
      map("k").to("up_arrow"),
      map("l").to("right_arrow"),
      map("b").to("left_arrow", "left_option"),
      map("e").to("right_arrow", "left_option"),
    ]),
    createLayer("v").manipulators([
      map("j").to("down_arrow", "shift"),
      map("h").to("left_arrow", "shift"),
      map("k").to("up_arrow", "shift"),
      map("l").to("right_arrow", "shift"),
      map("b").to({
        key_code: "left_arrow",
        modifiers: ["left_option", "shift"],
      }),
      map("e").to({
        key_code: "right_arrow",
        modifiers: ["left_option", "shift"],
      }),
    ]),
  ];
}
