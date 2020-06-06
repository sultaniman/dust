defmodule Dust.Dom do
  @moduledoc false
  @type selector() :: String.t()
  @type attr() :: String.t()
  @type document() :: Floki.html_tree() | Floki.html_tag()

  @spec attr(document(), selector(), attr()) :: list(String.t())
  def attr(document, selector, attr) do
    document
    |> Floki.find(selector)
    |> Floki.attribute(attr)
  end

  def error_image, do: "data:image/png;base64,data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAABgAAAAYCAYAAADgdz34AAADMUlEQVRIS7WVTWwTRxTHf4vtkN212ygNUWJDqFCICQkplEJpCa3SQhFfBwRSK7i3l1aqkIpU9doDAlGpai/toYdKtEW9tsfCAS4gVYqSGlBiQ/BXCDg2sb279rL2VJvirZfYiQEx0mj26c38f/tm3ryReMFNesH6tAxIgOxBOQX0AfEK+jfrwFjpB1sGpFGuqGtDo77BMBXLQp+JX+++HdklSZJYDtISIIX8odzV9VvHsaPg9UAuR346RunGzRM9WubX5wJEoK0TJdI5+na/b1MYYnfAMDC1IrnJSDSLPjQEZjPIihGkkD9Ve3q+Cxz4ABbykEo7WoVUCi2Z+iyE8f0zAe6D30K5+8p7Y53zly67NLp3vIFVLpOdmMx60dd3Q7ERZNkI0ihfK6HgV4H9e5n76Wd6heZoVHbsWfwuzs2hJ5JnghhfPhUggRzyIN1ac2C/X+rs4P6Fiy6AtX33op6oVsmMTxQriE3rMFJPQppGkEb5QVnf97E69g4ikSLz12UX4NG2txwtPZtFjyd/DKJ/0hJgFv9mQXWi68hBD+3tiOko8+MTLoD52psurfnJSEUS0kgvxRv1joYRpFH+UDdsOCTv3oWYuYvIPST7T8QFKG/Z6QKU8nn0eOLPIPrhZQFp2ke9inrlpX3vgxCI2O3F0W7tkb+dtaWh7UvOtJBIYhXye4KUrtacSyJIo1zzhwd2rn59K9VoDAoNs69h2pu6hhZPXg+iO/vnAswiH/cGAr8H9o4h9BLizowj9HBq2iXaMbCxIUR7kMHMZT8KYVy0JziAWklQR4b7feEBqremFktCrS1EY64z0DeONARYpmmfhVNCHMAs6hdtHS+fVcbeReRyiERyiYASnfw/Nfu3NKsOlBbymJn5071o5xxAGvmCOjx8wvdqH9XpGJhN61dT4ZrjkW5gzN37JYhxsg6gnpcHw6d8fhXxILOiyHITzHyBcjb3bRDtcwcwhX8w4FfGsaw2USo9FwAwi6zaOkDxZn0WrQK8gAwowOrHtgewu+2vn29fjipQedwtoAzo/PeU2nb1yXtg27ZQrddse2x0621IDWSPNqzebv3Rf9Y9+xdt5UUo4hALvQAAAABJRU5ErkJggg=="
end
