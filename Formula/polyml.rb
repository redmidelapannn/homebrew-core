class Polyml < Formula
  desc "Standard ML implementation"
  homepage "https://www.polyml.org/"
  url "https://github.com/polyml/polyml/archive/v5.7.1.tar.gz"
  sha256 "d18dd824b426edaed1cec71dded354b57df9ebdbd38863bc7540a60bd0667028"
  head "https://github.com/polyml/polyml.git"

  bottle do
    rebuild 1
    sha256 "4cdd4d6c7f5db402497d969db0abd5a3048b038146afc97f8041446bf6699846" => :high_sierra
    sha256 "b493074c483ca78047ffbb7a36660d053ab78dcb4919dce7bdc4e7d1a5cadd2d" => :sierra
    sha256 "c846f2a30a38171313fddd7380b7966897e938ac758b50c49e195cdc43c59ac7" => :el_capitan
  end

  def install
    system "./configure", "--disable-dependency-tracking", "--disable-debug",
                          "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end
end
