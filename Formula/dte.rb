class Dte < Formula
  desc "Small and easy to use console text editor"
  homepage "https://craigbarnes.gitlab.io/dte/"
  url "https://github.com/craigbarnes/dte/releases/download/v1.6/dte-1.6.tar.gz"
  sha256 "07a1f39831aa26c23ff635ab440983d84162156da199eaa06f0cb75149a9bbf4"
  head "https://github.com/craigbarnes/dte.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "125ed0de80e53be10c7e2616711e1c2bcb8e6b30e757d990480d9c811d1bfb4f" => :high_sierra
    sha256 "9f244511dc462da9f071f8c5a6abb65e11419644f6dbc327986c0e7e6f9294fe" => :sierra
    sha256 "797b894ad46ea495b20ab4152532094ba42b91d7f5d10590757ba194293c0a8e" => :el_capitan
  end

  def install
    system "make", "-j#{ENV.make_jobs}"
    system "make", "prefix=#{prefix}", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/dte -V")
    assert_match "syntax/ruby", shell_output("#{bin}/dte -B")
  end
end
