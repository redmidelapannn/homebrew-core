class Cdlabelgen < Formula
  desc "CD/DVD inserts and envelopes"
  homepage "https://www.aczoom.com/tools/cdinsert/"
  url "https://www.aczoom.com/pub/tools/cdlabelgen-4.3.0.tgz"
  sha256 "94202a33bd6b19cc3c1cbf6a8e1779d7c72d8b3b48b96267f97d61ced4e1753f"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "2a1a2ddc1ed60eae00393447d86421f060e0dc2a0adc0c25221d634c1775f343" => :sierra
    sha256 "2a1a2ddc1ed60eae00393447d86421f060e0dc2a0adc0c25221d634c1775f343" => :el_capitan
    sha256 "2a1a2ddc1ed60eae00393447d86421f060e0dc2a0adc0c25221d634c1775f343" => :yosemite
  end

  def install
    man1.mkpath
    system "make", "install", "BASE_DIR=#{prefix}"
  end

  test do
    system "#{bin}/cdlabelgen", "-c", "TestTitle", "--output-file", "testout.eps"
    File.file?("testout.eps")
  end
end
