import {
  FromKeyParam,
  ifApp,
  layer,
  map,
  rule,
  writeToProfile,
} from "karabiner.ts";
import { createVimLayer } from "./vim-layer";

function createKeyToLinkMap(
  key: FromKeyParam,
  link: string,
  alias: string = ""
) {
  return map(key).to$(`~/bin/find-or-open-tab ${link} ${alias}`);
}

function rectangle(key: FromKeyParam, name: string) {
  return map(key).to$(`open -g rectangle://execute-action?name=${name}`);
}

writeToProfile({ name: "Default profile" }, [
  ...createVimLayer(),

  rule("Tap Caps Lock for ESC or Hold for Control").manipulators([
    map("caps_lock", null, "any")
      .to([{ key_code: "left_control", lazy: true }])
      .toIfAlone("escape"),
  ]),

  layer("tab").manipulators([
    map("h").toApp("Obsidian"),
    map("j").toApp("Google Chrome"),
    map("k").toApp("Ghostty"),
    map("l").toApp("Visual Studio Code"),
    map(";").toApp("Slack"),

    map("o", null, "any").toAfterKeyUp([
      {
        key_code: "tab",
        modifiers: ["right_command"],
        hold_down_milliseconds: 20,
      },
      { key_code: "vk_none" },
    ]),
    map("i", null, "any").toAfterKeyUp([
      {
        key_code: "grave_accent_and_tilde",
        modifiers: ["right_command"],
        hold_down_milliseconds: 20,
      },
      { key_code: "vk_none" },
    ]),

    createKeyToLinkMap("m", "https://open.spotify.com"),
    createKeyToLinkMap("n", "https://www.notion.so"),
    createKeyToLinkMap("y", "https://www.youtube.com"),
    createKeyToLinkMap(
      "t",
      "https://www.google.com/search?q=stopwatch",
      "https://www.google.com/search?q=timer"
    ),

    map("p").to$("open raycast://extensions/thomas/visual-studio-code/index"),
  ]),

  layer("w", "Ctrl+w")
    .modifiers("left_control")
    .configKey((v) => v.toIfAlone("w", "left_control"), false)
    .manipulators([
      rectangle("j", "bottom-half"),
      rectangle("k", "top-half"),
      rectangle("h", "left-half"),
      rectangle("l", "right-half"),
      rectangle("return_or_enter", "maximize"),
      rectangle("o", "restore"),
    ]),

  rule(
    "Chrome: Change ctrl+np to arrow keys",
    ifApp(["^com\\.google\\.Chrome", "^com\\.tinyspeck\\.slackmacgap"])
  ).manipulators([
    map("n", "left_control").to("down_arrow"),
    map("p", "left_control").to("up_arrow"),
  ]),

  rule(
    "Chrome: improve new tab vimium behaviour",
    ifApp(["^com\\.google\\.Chrome$"])
  ).manipulators([
    map("t", "command").to([
      { key_code: "t" },
      { key_code: "vk_none", hold_down_milliseconds: 100 },
      {
        key_code: "l",
        modifiers: ["command"],
      },
      { key_code: "delete_or_backspace" },
    ]),
  ]),

  rule("Disable hide and minimise").manipulators([
    map("m", "command").toNone(),
    map("h", "command").toNone(),
  ]),
]);
