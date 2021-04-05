/* eslint no-console:0 */

import flatpickr from "flatpickr";
import { Japanese as flatpickrJa } from "flatpickr/dist/l10n/ja";
import "flatpickr/dist/themes/light.css";

flatpickr.localize(flatpickrJa);

document.addEventListener("DOMContentLoaded", () => {
  flatpickr(".flatpickr-date", {
    wrap: true,
    allowInput: true,
  });

  flatpickr(".flatpickr-datetime", {
    wrap: true,
    allowInput: true,
    enableTime: true,
    enableSeconds: true,
    dateFormat: "Y-m-d H:i:S",
  });
});
