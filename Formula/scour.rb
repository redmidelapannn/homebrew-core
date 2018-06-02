class Scour < Formula
  include Language::Python::Virtualenv

  desc "SVG file scrubber"
  homepage "https://www.codedread.com/scour/"
  url "https://github.com/scour-project/scour/archive/v0.36.tar.gz"
  sha256 "1b6820430c671c71406bf79afced676699d03bd3fcc65f01a651da5dcbcf3d3b"
  head "https://github.com/scour-project/scour.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "7446741b8ec9cf37fea80a1501aff234fc25b88b43a30439484586bf8fb849e4" => :high_sierra
    sha256 "1bde9a2dfbb23d2985d140b088c6795a40906db48346eb4c53b047d19e8c6ce0" => :sierra
    sha256 "6ef2cd490bef41041afb2a108952707b51ec8fa311a36ad5ce968b1ee45186a7" => :el_capitan
  end

  depends_on "python"

  resource "six" do
    url "https://files.pythonhosted.org/packages/16/d8/bc6316cf98419719bd59c91742194c111b6f2e85abac88e496adefaf7afe/six-1.11.0.tar.gz"
    sha256 "70e8a77beed4562e7f14fe23a786b54f6296e34344c23bc42f07b15018ff98e9"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    system "#{bin}/scour", "-i", test_fixtures("test.svg"), "-o", "scrubbed.svg"
    assert_predicate testpath/"scrubbed.svg", :exist?
  end
end
