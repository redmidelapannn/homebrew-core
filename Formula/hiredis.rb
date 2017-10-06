class Hiredis < Formula
  desc "Minimalistic client for Redis"
  homepage "https://github.com/redis/hiredis"
  url "https://github.com/redis/hiredis/archive/v0.13.3.tar.gz"
  sha256 "717e6fc8dc2819bef522deaca516de9e51b9dfa68fe393b7db5c3b6079196f78"
  head "https://github.com/redis/hiredis.git"

  bottle do
    cellar :any
    rebuild 1
    sha256 "c1be14e58e93d6e1bcdfa8cb473bf2a28e72c6b8631150787a6a26326083588b" => :high_sierra
    sha256 "e526a615022fd6aa5a07b2b9337c4155b4a805c0856c07a1b59699271db36e19" => :sierra
    sha256 "3154b3a6d5c86db07c225b948c579c1dd6f3ef47c2093dfe711304c0fd8c80a3" => :el_capitan
  end

  def install
    # Architecture isn't detected correctly on 32bit Snow Leopard without help
    ENV["OBJARCH"] = "-arch #{MacOS.preferred_arch}"

    system "make", "install", "PREFIX=#{prefix}"
    pkgshare.install "examples"
  end

  test do
    # running `./test` requires a database to connect to, so just make
    # sure it compiles
    system ENV.cc, "-I#{include}/hiredis", "-L#{lib}", "-lhiredis",
           pkgshare/"examples/example.c", "-o", testpath/"test"
    assert_predicate testpath/"test", :exist?
  end
end
