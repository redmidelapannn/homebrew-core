class BoostBcpAT168 < Formula
  desc "Utility for extracting subsets of the Boost library"
  homepage "https://www.boost.org/doc/tools/bcp/"
  url "https://dl.bintray.com/boostorg/release/1.68.0/source/boost_1_68_0.tar.bz2"
  sha256 "7f6130bc3cf65f56a618888ce9d5ea704fa10b462be126ad053e80e553d6d8b7"

  bottle do
    cellar :any_skip_relocation
    sha256 "4b5be86ad2d1dcf9b9fcbfd969075aaf87a6944db53ca0f1356505395d6a6c9e" => :mojave
    sha256 "6bc9fb1487214f81996d95d27b9b74ffc4a0c020a8531f80990294ee777d3579" => :high_sierra
    sha256 "cbdd82734d4bc41343361f5c6d60da5a1ad2d8c8c9061bdb00f8ae36c6818051" => :sierra
  end

  keg_only :versioned_formula

  depends_on "boost-build@1.68" => :build

  def install
    cd "tools/bcp" do
      system "b2"
      prefix.install "../../dist/bin"
    end
  end

  test do
    system bin/"bcp", "--help"
  end
end
