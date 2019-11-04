require "language/node"

class Ungit < Formula
  desc "The easiest way to use git. On any platform. Anywhere"
  homepage "https://github.com/FredrikNoren/ungit"
  url "https://registry.npmjs.org/ungit/-/ungit-1.4.48.tgz"
  sha256 "691447a39ac4729c2b0ee2705cc21b9d239063354b78583853d1c053347758b1"

  bottle do
    cellar :any_skip_relocation
    sha256 "eebad796f000959d66125db8409bb0d6aaed34f060d058b751160c0f0deb2694" => :catalina
    sha256 "6b56d2633c64ab9b28ad7682c8e51d245adab40a33f893a67f3764f09d2a8b0b" => :mojave
    sha256 "7f885d76984cd44b91310fe8e727799899da7d3b8212bb5b80b7fcf5d25b2681" => :high_sierra
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    require "nokogiri"

    pid = fork do
      exec bin/"ungit", "--no-launchBrowser", "--autoShutdownTimeout", "12000" # give it an idle timeout to make it exit
    end
    sleep 8
    assert_match "ungit", Nokogiri::HTML(shell_output("curl -s 127.0.0.1:8448/")).at_css("title").text
  ensure
    Process.kill("TERM", pid)
    Process.wait(pid)
  end
end
