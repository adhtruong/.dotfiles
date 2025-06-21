import {
  ifApp,
  layer,
  map,
  rule,
  to$,
  toApp,
  withCondition,
  writeToProfile,
} from "karabiner.ts";
import { createLayer, doubleTap, ifLayer, mapToLink, rectangle } from "./utils";
import { createVimLayer } from "./vim-layer";

const applicationManipulators = [
  map("h").toApp("Obsidian"),
  map("j").toApp("Google Chrome"),
  map("k").toApp("Ghostty"),
  doubleTap("l").toApp("Cursor").singleTap(toApp("Visual Studio Code")),
  map(";").toApp("Slack"),

  map("o").toAfterKeyUp([
    {
      key_code: "tab",
      modifiers: ["right_command"],
      hold_down_milliseconds: 20,
    },
    { key_code: "vk_none" },
  ]),
  map("i").toAfterKeyUp([
    {
      key_code: "grave_accent_and_tilde",
      modifiers: ["right_command"],
      hold_down_milliseconds: 20,
    },
    { key_code: "vk_none" },
  ]),

  mapToLink("g", "https://calendar.google.com"),
  mapToLink("e", "https://mail.google.com/"),
  mapToLink("m", "https://open.spotify.com"),
  mapToLink("n", "https://www.notion.so"),
  mapToLink("y", "https://www.youtube.com"),
  mapToLink(
    "t",
    "https://www.google.com/search?q=stopwatch",
    "https://www.google.com/search?q=timer"
  ),

  doubleTap("p")
    .to(
      to$("open raycast://extensions/degouville/cursor-recent-projects/index")
    )
    .singleTap(
      to$("open raycast://extensions/thomas/visual-studio-code/index")
    ),
];

writeToProfile({ name: "Default profile" }, [
  rule("Tap Caps Lock for ESC or Hold for Control").manipulators([
    map("caps_lock", null, "any")
      .to([{ key_code: "left_control", lazy: true }])
      .toIfAlone("escape"),
  ]),

  rule("Hold ; for Control").manipulators(
    withCondition(ifLayer().unless())([
      map(";", "control", undefined).toIfAlone({
        key_code: "spacebar",
        modifiers: ["left_command"],
      }),
      map(";", "optionalAny")
        .toIfAlone(";", undefined, { halt: true })
        .toIfHeldDown("right_control", undefined, {})
        .parameters({
          "basic.to_if_held_down_threshold_milliseconds": 50,
        }),
    ])
  ),

  layer("tab").manipulators([
    ...applicationManipulators,

    // Activate resizing layer
    map("w").toMeh(),
  ]),

  ...(["e"] as const).map((key) =>
    createLayer(key).manipulators(applicationManipulators)
  ),

  createLayer("r").manipulators([
    rectangle("j", "bottom-half"),
    rectangle("k", "top-half"),
    rectangle("h", "left-half"),
    rectangle("l", "right-half"),
    rectangle("return_or_enter", "maximize"),
    rectangle("o", "restore"),
  ]),

  ...createVimLayer(),

  createLayer("f").manipulators([
    map("j").to({ key_code: "tab", modifiers: ["right_command"] }),
    map("k").to({ key_code: "left_shift", modifiers: ["right_command"] }),

    map("l").to({
      key_code: "grave_accent_and_tilde",
      modifiers: ["right_command"],
    }),
    map("h").to({ key_code: "left_shift", modifiers: ["right_command"] }),

    map("o").toAfterKeyUp([
      {
        key_code: "tab",
        modifiers: ["right_command"],
        hold_down_milliseconds: 20,
      },
      { key_code: "vk_none" },
    ]),
    map("i").toAfterKeyUp([
      {
        key_code: "grave_accent_and_tilde",
        modifiers: ["right_command"],
        hold_down_milliseconds: 20,
      },
      { key_code: "vk_none" },
    ]),

    doubleTap("u")
      .to({
        key_code: "q",
        modifiers: ["right_command"],
      })
      .singleTap({
        key_code: "w",
        modifiers: ["right_command"],
      }),
    map("right_shift").to({
      key_code: "escape",
      modifiers: ["right_command"],
    }),
  ]),

  rule("Ghostty remap window commands to tmux", ifApp("ghostty")).manipulators([
    map("t", "command").toTypeSequence("`c"),
    map("w", "command").toTypeSequence("`x"),
    map("n", "command").toTypeSequence("`t"),
  ]),

  rule(
    "Chrome: Change ctrl+np to arrow keys",
    ifApp(["Chrome", "slack"])
  ).manipulators([
    map("n", "left_control").to("down_arrow"),
    map("p", "left_control").to("up_arrow"),

    map("o", "left_control").to("[", "left_command"),
    map("i", "left_control").to("]", "left_command"),
  ]),

  rule(
    "Chrome: improve new tab vimium behaviour",
    ifApp("Chrome")
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
