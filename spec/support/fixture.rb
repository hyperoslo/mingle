#  Read a fixture.
#
# file - A String describing a filename.
#
# Returns a String.
def fixture(file)
  File.read "spec/fixtures/#{file}"
end
