/* eslint no-console:0 */

import { Controller } from "stimulus";

import {
  flatpickrFor,
  setMinMaxOnDateSelection,
} from "../../flatpickr_helper";

export default class extends Controller {
  connect() {
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
  }
};
