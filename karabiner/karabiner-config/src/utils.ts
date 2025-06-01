import {
  type FromKeyParam,
  ifVar,
  layer,
  type LayerKeyParam,
  map,
  mapDoubleTap,
  to$,
} from "karabiner.ts";

function toLink(link: string, alias = "") {
  return to$(`~/bin/find-or-open-tab ${link} ${alias}`);
}

export function mapToLink(key: FromKeyParam, link: string, alias = "") {
  return map(key).to(toLink(link, alias));
}

export function rectangle(key: FromKeyParam, name: string) {
  return map(key).to$(`open -g rectangle://execute-action?name=${name}`);
}

export function ifLayer() {
  return ifVar("__layer", 1);
}

export function createLayer(key: LayerKeyParam) {
  return layer(key)
    .modifiers("control")
    .configKey((v) => v.toIfAlone(key, "left_control"), false);
}

export function doubleTap(key: LayerKeyParam, delay = 250) {
  return mapDoubleTap(key, delay);
}
