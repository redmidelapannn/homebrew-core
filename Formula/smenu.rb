class Smenu < Formula
  desc "Command-line tool that turns its input into interactive selection menus"
  homepage "https://github.com/p-gen/smenu"
  url "https://github.com/p-gen/smenu/archive/v0.9.9.tar.gz"
  sha256 "04c9ea56130a8d2398c5fba712f6e099d7a7adb0d9072d1610624fe902b5c54d"
  head "https://github.com/p-gen/smenu.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "310c5e9004e0ca027257eee757d08c5737c0c43ca389d1c2e0f20422d54b9878" => :high_sierra
    sha256 "88f5aa3b749570d8d87612fb1214ae87528aac33ce28f28a12a9b5c14a3251a5" => :sierra
    sha256 "a34b219e4787402fd42b82ce6ab67877e511774a69b35fe5180d1e20b3cdbfcf" => :el_capitan
  end

  def install
    system "./build.sh", "--disable-dependency-tracking",
                         "--disable-silent-rules",
                         "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    assert_match version.to_s.sub("HEAD-", ""), shell_output("#{bin}/smenu -V 2>&1")
  end
end
