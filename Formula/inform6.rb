class Inform6 < Formula
  desc "Design system for interactive fiction"
  homepage "https://inform-fiction.org/inform6.html"
  head "https://github.com/DavidGriffith/inform6unix.git"

  stable do
    url "https://ifarchive.org/if-archive/infocom/compilers/inform6/source/old/inform-6.33-6.12.1.tar.gz"
    version "6.33-6.12.1"
    sha256 "9170d6a0283aa65e1205621e89f78d674c8df978ee9c0b1c67f8b1aea4722a77"
  end

  bottle do
    rebuild 1
    sha256 "38cd3c6eb334a9ec813582fc8caa5d081e1f4affb3fb736f61c9b4b21b29277d" => :high_sierra
    sha256 "b1ac9521cf5489f0bb7e2e3bfc090256d32ec7f34fa6654c43a776e32f6d5b1c" => :sierra
    sha256 "62b22aa387a445a75239bc659f055c21fdb04ceb12b2b7794cb165ec9a9157ed" => :el_capitan
  end

  resource "Adventureland.inf" do
    url "https://inform-fiction.org/examples/Adventureland/Adventureland.inf"
    sha256 "3961388ff00b5dfd1ccc1bb0d2a5c01a44af99bdcf763868979fa43ba3393ae7"
  end

  def install
    system "make", "PREFIX=#{prefix}", "MAN_PREFIX=#{man}", "install"
  end

  test do
    resource("Adventureland.inf").stage do
      system "#{bin}/inform", "Adventureland.inf"
      assert_predicate Pathname.pwd/"Adventureland.z5", :exist?
    end
  end
end
