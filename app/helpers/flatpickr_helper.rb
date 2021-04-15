module FlatpickrHelper
  def flatpickr_id(element_id, suffix = '')
    with_flatpickr = "#{element_id}-flatpickr"
    suffix.empty? ? with_flatpickr : "#{with_flatpickr}-#{suffix}"
  end
end
