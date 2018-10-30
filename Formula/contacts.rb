# Use a sha1 instead of a tag, as the author has not provided a tag for
# this release. In fact, the author no longer uses this software, so it
# is a candidate for removal if no new maintainer is found.
class Contacts < Formula
  desc "Command-line tool to access macOS's Contacts (formerly 'Address Book')"
  homepage "http://www.gnufoo.org/contacts/contacts.html"
  url "https://github.com/dhess/contacts/archive/4092a3c6615d7a22852a3bafc44e4aeeb698aa8f.tar.gz"
  version "1.1a-3"
  sha256 "e3dd7e592af0016b28e9215d8ac0fe1a94c360eca5bfbdafc2b0e5d76c60b871"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "3211f383e931996569009821ae3c0e86e77a2831e2a1ae4df256ee5169969937" => :mojave
    sha256 "93867664f31be25a97c632fed3fc7f3a245355bc17e4d0c6d586f7e4363a6cf4" => :high_sierra
    sha256 "dcb7ef450b167cf19fe7ef809fa0c0ddaa2e416e7969ae719ce53a3cb235f577" => :sierra
  end

  depends_on :xcode => :build

  def install
    system "make", "SDKROOT=#{MacOS.sdk_path}"
    bin.install "build/Deployment/contacts"
    man1.install gzip("contacts.1")
  end

  test do
    output = shell_output("#{bin}/contacts -h 2>&1", 2)
    assert_match "displays contacts from the AddressBook database", output
  end
end
