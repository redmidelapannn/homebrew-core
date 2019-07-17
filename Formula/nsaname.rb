# Documentation: https://docs.brew.sh/Formula-Cookbook
#                https://rubydoc.brew.sh/Formula
# PLEASE REMOVE ALL GENERATED COMMENTS BEFORE SUBMITTING YOUR PULL REQUEST!
class Nsaname < Formula
  desc "Create NSA styled project names."
  homepage "https://github.com/mdoza/nsaname"
  url "https://github.com/mdoza/nsaname/archive/v0.1.0.tar.gz"
  version "0.1.0"
  sha256 "358973ca504d56261ea6f5d2c422699aeabfb25d0f24afa9ed4066ab4f9fc697"
  bottle do
    cellar :any_skip_relocation
    sha256 "463ee4fa905a95515fba411656d3e17255ec94072b3003e61baa47b7ce6cc3ad" => :mojave
    sha256 "de670de45a3e106fc792d1ae1d8898dadffd586ce7ecb43c314c05bf53715c40" => :high_sierra
    sha256 "6078647d65436d1f99b633160e37ad6269d5afea7b35171cbb1259a56c9e75c6" => :sierra
  end

  # depends_on "cmake" => :build

  def install
    # ENV.deparallelize  # if your formula fails when building in parallel
    # Remove unrecognized options if warned by configure
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    # `test do` will create, run in and delete a temporary directory.
    #
    # This test will fail and we won't accept that! For Homebrew/homebrew-core
    # this will need to be a test that verifies the functionality of the
    # software. Run the test with `brew test nsaname`. Options passed
    # to `brew install` such as `--HEAD` also need to be provided to `brew test`.
    #
    # The installed folder is not in the path, so use the entire path to any
    # executables being tested: `system "#{bin}/program", "do", "something"`.
    system "false"
  end
end
