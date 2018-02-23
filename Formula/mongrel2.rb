class Mongrel2 < Formula
  desc "Application, language, and network architecture agnostic web server"
  homepage "https://mongrel2.org/"
  head "https://github.com/mongrel2/mongrel2.git", :branch => "develop"

  stable do
    url "https://github.com/mongrel2/mongrel2/releases/download/v1.11.0/mongrel2-v1.11.0.tar.bz2"
    sha256 "917f2ce07c0908cae63ac03f3039815839355d46568581902377ba7e41257bed"

    # ensure unit tests work on 1.11.0. remove after next release
    patch do
      url "https://github.com/mongrel2/mongrel2/commit/7cb8532e2ecc341d77885764b372a363fbc72eff.patch?full_index=1"
      sha256 "fa7be14bf1df8ec3ab8ae164bde8eb703e9e2665645aa627baae2f08c072db9a"
    end
  end

  bottle do
    cellar :any
    rebuild 1
    sha256 "20ec374a3f071722f627ed37a24ef84ae6d119b89ad71ec1e3609ad27937e1af" => :high_sierra
    sha256 "b498ce67c3f4a3e2602493078912aa0615810c8b626d19b6cf14cc987bbdd5dd" => :sierra
    sha256 "e49f3f54250d0fa137ab731e95a780efedbeed00f890d0f5d685cc9142aa4a6e" => :el_capitan
  end

  depends_on "zeromq"

  def install
    # Build in serial. See:
    # https://github.com/Homebrew/homebrew/issues/8719
    ENV.deparallelize

    # Mongrel2 pulls from these ENV vars instead
    ENV["OPTFLAGS"] = "#{ENV.cflags} #{ENV.cppflags}"
    ENV["OPTLIBS"] = "#{ENV.ldflags} -undefined dynamic_lookup"

    system "make", "all"
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    system bin/"m2sh", "help"
  end
end
