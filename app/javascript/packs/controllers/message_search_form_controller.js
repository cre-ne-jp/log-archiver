/* eslint no-console:0 */

import { Controller } from "stimulus";

import {
  flatpickrFor,
  setMinMaxOnDateSelection,
} from "../flatpickr_helper";

class MessageSearchFormController extends Controller {
  connect() {
    setMinMaxOnDateSelection(
      flatpickrFor("message_search_since"),
      flatpickrFor("message_search_until")
    );
  }
}

export default MessageSearchFormController;
