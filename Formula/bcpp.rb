class Bcpp < Formula
  desc "C(++) beautifier"
  homepage "https://invisible-island.net/bcpp/"
  url "https://invisible-mirror.net/archives/bcpp/bcpp-20150811.tgz"
  sha256 "6a18d68a09c4a0e8bf62d23d13ed7c8a62c98664a655f9d648bc466240ce97c3"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "9826659a0a67897d1b4df9951dbf0d945435c29b26f11109a511f61defe20c25" => :high_sierra
    sha256 "b99ef83e72d0b3f0b7272402bdfe742c0fe916f753b80af411113e34a9404ffa" => :sierra
    sha256 "e9e764725f9c694a0bb7435429719db438f33ebef7bbf6cd2f99eb5f55eb2c59" => :el_capitan
  end

  def install
    system "./configure", "--prefix=#{prefix}", "--mandir=#{man}"
    system "make", "install"
    etc.install "bcpp.cfg"
  end

  test do
    (testpath/"test.txt").write <<-EOS.undent
              test
                 test
          test
                test
    EOS
    system bin/"bcpp", "test.txt", "-fnc", "#{etc}/bcpp.cfg"
    assert_predicate testpath/"test.txt.orig", :exist?
    assert_predicate testpath/"test.txt", :exist?
  end
end
