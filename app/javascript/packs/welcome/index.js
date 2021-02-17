/* eslint no-console:0 */

import {
  flatpickrFor,
  setMinMaxOnDateSelection,
} from "../flatpickr_helper";

const onLoad = () => {
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

  flatpickrPairs.forEach(({ since, until }) => {
    setMinMaxOnDateSelection(since, until);
  });
};

export default onLoad;
