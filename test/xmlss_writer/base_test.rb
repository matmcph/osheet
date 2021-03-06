require "assert"
require 'osheet/xmlss_writer'

module Osheet

  class XmlssWriter::BaseTest < Assert::Context
    desc "XmlssWriter::Base"
    before { @writer = XmlssWriter::Base.new }
    subject { @writer }

    should have_readers :workbook, :styles
    should have_writer :workbook

  end

  class XmlssWriter::WorkbookTest < XmlssWriter::BaseTest
    desc "workbook"
    before do
      @workbook = Workbook.new {
        title "xmlss"
        worksheet { name "testsheet1" }
      }
    end

    should "only allow writing an Osheet::Workbook" do
      assert_nothing_raised do
        subject.workbook = @workbook
      end
      assert_raises ArgumentError do
        subject.workbook = "poo"
      end
    end

    should "not allow writing a workbook that has multiple worksheets with the same name" do
      assert_raises ArgumentError do
        subject.workbook = Workbook.new {
          title "invalid"
          worksheet { name "testsheet1" }
          worksheet { name "testsheet1" }
        }
      end
    end

    should "create an Xmlss workbook" do
      assert_nothing_raised do
        subject.workbook = @workbook
      end
      assert_kind_of ::Xmlss::Workbook, subject.workbook
      assert_equal @workbook.worksheets.size, subject.workbook.worksheets.size
    end

  end

  class XmlssWriter::ToDataTest < Assert::Context
    desc "XmlssWriter::Base"
    before do
      @writer = XmlssWriter::Base.new({
        :workbook => Workbook.new {
          title "written"
          worksheet {
            name "Poo!"
            column
            row {
              cell {
                data 1
                format :number
              }
            }
          }
        }
      })
    end
    after do
      # remove any test files this creates
    end
    subject { @writer }

    should have_instance_methods :to_data, :to_file

    should "return string xml data" do
      xml_data = nil
      assert_nothing_raised do
        xml_data = subject.to_data
      end
      assert_kind_of ::String, xml_data
      assert_match /^<\?xml/, xml_data
    end

    should "write xml data to a file path" do
      path = nil
      assert_nothing_raised do
        path = subject.to_file("./tmp/base_test.xls")
      end
      assert_kind_of ::String, path
      assert_equal './tmp/base_test.xls', path
      assert File.exists?(path)
    end

  end

end
