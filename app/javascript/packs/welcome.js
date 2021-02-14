/* eslint no-console:0 */

import { flatpickrFor } from "./flatpickr_helper";

const index = () => {
  console.log("welcome/index");

  const flatpickrPairs = [
    {
      since: flatpickrFor("message_search_since"),
      until: flatpickrFor("message_search_until")
    },
    {
      since: flatpickrFor("message_period_since"),
      until: flatpickrFor("message_period_until")
    },
  ];

  const flatpickrSince = flatpickrFor("message_search_since");
  const flatpickrUntil = flatpickrFor("message_search_until");

  const dateFromArray = (dates) => (dates.length < 1) ? null : dates[0];

  flatpickrPairs.forEach(({ since, until }) => {
    since.set("onChange", (selectedDates, dateStr, instance) => {
      until.set("minDate", dateFromArray(selectedDates));
    });

    until.set("onChange", (selectedDates, dateStr, instance) => {
      since.set("maxDate", dateFromArray(selectedDates));
    });
  });
};

export default {
  index,
};
