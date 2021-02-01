/* eslint no-console:0 */

import { flatpickrFor } from "./flatpickr_helper";

const index = () => {
  console.log("welcome/index");

  const flatpickrSince = flatpickrFor("message_search_since");
  const flatpickrUntil = flatpickrFor("message_search_until");

  const dateFromArray = (dates) => (dates.length < 1) ? null : dates[0];

  flatpickrSince.set("onChange", (selectedDates, dateStr, instance) => {
    flatpickrUntil.set("minDate", dateFromArray(selectedDates));
  });

  flatpickrUntil.set("onChange", (selectedDates, dateStr, instance) => {
    flatpickrSince.set("maxDate", dateFromArray(selectedDates));
  });
};

export default {
  index,
};
