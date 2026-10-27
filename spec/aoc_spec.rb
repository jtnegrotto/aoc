require 'open3'

YEARS = Dir.glob("20*").map(&:to_i)
DAYS = 12
PARTS = 2

ROOT = Pathname.new(__dir__).join('..')

LANGUAGES = [
  {
    name: "ruby",
    display_name: "Ruby",
    extension: ".rb",
    call: -> (program_path, input_path) {
      Open3.capture2e("ruby", program_path, input_path)
    },
  },
]

RSpec.describe "Advent of Code" do
  LANGUAGES.each do |language|
    describe language[:display_name], lang: language[:name] do
      YEARS.each do |year|
        describe year, year: year do
          1.upto(DAYS) do |day|
            describe "Day #{day}", day: day do
              dir = ROOT.join(year.to_s, day.to_s.rjust(2, '0'))

              1.upto(PARTS) do |part|
                describe "Part #{part}", part: part do
                  program_path = dir.join("part#{part}#{language[:extension]}")

                  it "solves the example", example: true do
                    input_path = dir.join("example.txt")
                    output_path = dir.join("example.result#{part}.txt")

                    if !program_path.exist?
                      skip "Not implemented"
                    elsif !input_path.exist?
                      skip "Input not provided"
                    elsif !output_path.exist?
                      skip "Expected output not provided"
                    else
                      result, status = language[:call][program_path.to_s, input_path.to_s]
                      expect(status).to be_success
                      result = result.strip
                      expected = File.read(output_path.to_s).strip
                      expect(result).to eq(expected)
                    end
                  end

                  it "solves the puzzle", example: false do
                    input_path = dir.join("input.txt")
                    output_path = dir.join("input.result#{part}.txt")

                    if !program_path.exist?
                      skip "Not implemented"
                    elsif !input_path.exist?
                      skip "Input not provided"
                    elsif !output_path.exist?
                      skip "Expected output not provided"
                    else
                      result, status = language[:call][program_path.to_s, input_path.to_s]
                      expect(status).to be_success
                      result = result.strip
                      expected = File.read(output_path.to_s).strip
                      expect(result).to eq(expected)
                    end
                  end
                end
              end
            end
          end
        end
      end
    end
  end
end
