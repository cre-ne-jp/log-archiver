/* eslint no-console:0 */

import { Controller } from "stimulus";

import {
  flatpickrFor,
  setMinMaxOnDateSelection,
} from "../flatpickr_helper";

class MessagePeriodFormController extends Controller {
  connect() {
    setMinMaxOnDateSelection(
      flatpickrFor("message_period_since"),
      flatpickrFor("message_period_until")
    );
  }
}

export default MessagePeriodFormController;
