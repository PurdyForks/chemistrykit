# Encoding: utf-8

# this is where you can define generic helper functions that are inhereted by
# the rest of your formulas
class Formula < ChemistryKit::Formula::Base

	attr_reader :driver

	def initialize(driver)
    @driver = driver
    driver.manage.window.resize_to(1260, 1190)
  end

  def visit(url='/')
    driver.get(ENV['BASE_URL'] + url)
  end

  def find(locator)
    driver.find_element locator
  end

  def clear(locator)
    find(locator).clear
  end

  def type(locator, input)
    find(locator).send_keys input
  end

  def click_on(locator)
    find(locator).click
  end

  def displayed?(locator)
    driver.find_element(locator).displayed?
    true
    rescue Selenium::WebDriver::Error::NoSuchElementError
      false
  end

  def text_of(locator)
    find(locator).text
  end

  def title
    driver.title
  end

  def wait_for(seconds=5)
    Selenium::WebDriver::Wait.new(:timeout => seconds).until { yield }
  end

end
