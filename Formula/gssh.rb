class Gssh < Formula
  desc "SSH automation tool based on Groovy DSL"
  homepage "https://github.com/int128/groovy-ssh"
  url "https://github.com/int128/groovy-ssh/archive/2.9.0.tar.gz"
  sha256 "9199c675b91041858a246eee156c6ed0d65d153efafb62820f66d3722b9d17bf"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "25a482433665b6ecfe973dbb6da5881908116c837c4f418269915d2d7db1287d" => :sierra
    sha256 "0eccd246306b7ddf9af81aa2379c3c6b77c3a28958cac2aba5539feb7a969511" => :el_capitan
    sha256 "da718e14ec87ac5aff4b04ed8072977e7ffcec3ef171fff801ad4186fc03110b" => :yosemite
  end

  depends_on :java => "1.7+"

  def install
    ENV["CIRCLE_TAG"] = version
    system "./gradlew", "shadowJar"
    libexec.install "cli/build/libs/gssh.jar"
    bin.write_jar_script libexec/"gssh.jar", "gssh"
  end

  test do
    system bin/"gssh"
  end
end
