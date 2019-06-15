class Ghi < Formula
  desc "Work on GitHub issues on the command-line"
  homepage "https://github.com/stephencelis/ghi"
  url "https://github.com/stephencelis/ghi/archive/1.2.0.tar.gz"
  sha256 "ffc17cfbdc8b88bf208f5f762e62c211bf8fc837f447354ad53cce39b1400671"
  revision 4
  head "https://github.com/stephencelis/ghi.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "68b7d1074a230c97fc9dfc7ff1f656919be8d87036abce191a2732a906f17b82" => :mojave
    sha256 "68b7d1074a230c97fc9dfc7ff1f656919be8d87036abce191a2732a906f17b82" => :high_sierra
    sha256 "5458e00ed4ab5dcabea9ed642d4cdb86367d01a6f0177b3a5799a6e43dc44785" => :sierra
  end

  resource "multi_json" do
    url "https://rubygems.org/gems/multi_json-1.12.1.gem"
    sha256 "b387722b0a31fff619a2682c7011affb5a13fed2cce240c75c5d6ca3e910ecf2"
  end

  resource "pygments.rb" do
    url "https://rubygems.org/gems/pygments.rb-1.1.2.gem"
    sha256 "55a5deed9ecba6037ac22bf27191e0073bd460f87291b2f384922e4b0d59511c"
  end

  def install
    ENV["GEM_HOME"] = libexec
    resources.each do |r|
      r.fetch
      system "gem", "install", r.cached_download, "--no-document",
                    "--install-dir", libexec
    end
    bin.install "ghi"
    bin.env_script_all_files(libexec/"bin", :GEM_HOME => ENV["GEM_HOME"])
    man1.install "man/ghi.1"
  end

  test do
    system "#{bin}/ghi", "--version"
  end
end
