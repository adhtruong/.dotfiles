import { duoLayer, map } from "karabiner.ts";

export function createVimLayer() {
  return [
    duoLayer("f", ";", "vim-layer")
      .leaderMode({ sticky: true })
      .notification()
      .manipulators([
        map("j", null, "shift").to("down_arrow"),
        map("h", null, "shift").to("left_arrow"),
        map("k", null, "shift").to("up_arrow"),
        map("l", null, "shift").to("right_arrow"),

        map("i", null, "shift").to("left_arrow", "left_command"),
        map("o", null, "shift").to("right_arrow", "left_command"),

        map("b", null, "shift").to("left_arrow", "left_option"),
        map("w", null, "shift").to("right_arrow", "left_option"),
        map("e", null, "shift").to("right_arrow", "left_option"),
      ]),
  ];
}
