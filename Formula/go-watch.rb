class GoWatch < Formula
  desc "Portable Go replacement for GNU watch"
  homepage "https://github.com/ostera/watch"

  url "https://github.com/ostera/watch/archive/0.2.2.tar.gz"

  version "0.2.2"
  sha256 "d2a06ca79b78e1b2d205a6bfb1cdc8747691d82a61d1e35a2f3c9ec8579e7fc2"

  head "https://github.com/ostera/watch.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "4e548153561529bebc9e2517a89bab351c6e2a6b0b63690df3bd830c8a197145" => :el_capitan
    sha256 "ab17a463cb0cabf0fafaf0da3a4add6a8d5441cfde6aebfc435d7ea9e0930d73" => :yosemite
    sha256 "45897fbe91e85b13e1f1e09b9a81b5880a1d6ca686bda549243404e0fd0e1798" => :mavericks
  end

  depends_on "go"

  conflicts_with "watch"

  def install
    bin.mkdir
    system "make", "PREFIX=#{prefix}", "install"
  end

  test do
    system "watch", "-v"
  end
end
