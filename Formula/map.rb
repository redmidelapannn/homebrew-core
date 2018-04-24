class Map < Formula
  desc "Maps lines from stdin to commands"
  homepage "https://github.com/soveran/map"
  url "https://github.com/soveran/map/archive/0.1.1.tar.gz"
  sha256 "6903d2bb6d7e0cddceee487cc35b442e5e78a459785aa5ae7c84f13090f193f0"

  bottle do
    cellar :any_skip_relocation
    sha256 "ab18c57f6096a5e8d5c6d7bad826188af2e8559d2b8019c1dc99c3ca153925ad" => :high_sierra
    sha256 "6add4a0a53cde45cc9cfc20599eaa44ee62fd64920a525a4bddb3097cf5f05d3" => :sierra
    sha256 "5b8289f85bccab6d7dee2b95818bd36628fd9b6c7b94d755e2fcad4ddb5fbb09" => :el_capitan
  end

  def install
    system "make", "PREFIX=#{prefix}", "install"
  end

  test do
    assert_equal "foobar", shell_output("printf 'foo\nbar' | map f 'printf $f'")
  end
end
