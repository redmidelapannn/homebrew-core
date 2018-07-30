class Inform6 < Formula
  desc "Design system for interactive fiction"
  homepage "http://www.inform-fiction.org/inform6.html"
  head "https://github.com/DavidGriffith/inform6unix.git"

  stable do
    url "https://ifarchive.info/if-archive/programming/glulx/compilers/inform/source/inform-6.33-6.12.1.tar.gz"
    version "6.33-6.12.1"
    sha256 "9170d6a0283aa65e1205621e89f78d674c8df978ee9c0b1c67f8b1aea4722a77"
  end

  bottle do
    rebuild 1
    sha256 "6fd6643d7c837d95e5ccfe1db32c538885bb47b4f1d3dd36e010ea4ba7ab048f" => :high_sierra
    sha256 "cce0e54926422cbfd639ff9ffb163decf72e2b5f36de0f5e3794c2c5b909bce8" => :sierra
    sha256 "4c41eb25e67c2de168134c85629eda416585daa55b0c758d1e02626126b14bdd" => :el_capitan
  end

  resource "Adventureland.inf" do
    url "http://inform-fiction.org/examples/Adventureland/Adventureland.inf"
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
