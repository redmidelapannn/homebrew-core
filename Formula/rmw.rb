class Rmw < Formula
  desc "Safe-remove utility for the command-line"
  homepage "https://remove-to-waste.info/"
  url "https://github.com/theimpossibleastronaut/rmw/releases/download/v0.7.03/rmw-0.7.03.tar.gz"
  sha256 "60750279980b450df5b62f12a7c7153584b41acba7bdb4ecf96def043d50f71a"
  head "https://github.com/theimpossibleastronaut/rmw.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "9701803a58601492752f1c89d48593a4f979db6b6717b10fe687ed49c1b0f3dc" => :sierra
  end

  def install
    system "./configure", "--enable-debug=no",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    touch("foo")
    system "#{bin}/rmw"
    system "#{bin}/rmw", "-v", "foo"
    system "ls", "foo"
    system "#{bin}/rmw", "-u"
    system "ls", "foo"
  end
end
