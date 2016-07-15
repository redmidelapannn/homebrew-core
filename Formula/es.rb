class Es < Formula
  desc "Extensible shell with first class functions, lexical scoping, and more"
  homepage "https://wryun.github.io/es-shell/"
  url "https://github.com/wryun/es-shell/releases/download/v0.9.1/es-0.9.1.tar.gz"
  sha256 "b0b41fce99b122a173a06b899a4d92e5bd3cc48b227b2736159f596a58fff4ba"

  bottle do
    cellar :any_skip_relocation
    sha256 "b8588bd88d1e96f8a7093934ebd004c0890334899892137014a6cdcd641c2720" => :el_capitan
    sha256 "8d03d2211e286a2481f7f3876324c5db14a886c3b95585e873ecd99412928b41" => :yosemite
    sha256 "83d459a0d8b05ffd742b950053ce1ae1b9f4f0cc2fd1a5375fcd690a8aa9d5e5" => :mavericks
  end

  option "with-readline", "Use readline instead of libedit"

  depends_on "readline" => :optional
  depends_on "readline" => :linked

  conflicts_with "kes", :because => "both install 'es' binary"

  def install
    args = ["--prefix=#{prefix}"]
    args << "--with-readline" if build.with? "readline"
    system "./configure", *args
    system "make"

    man1.install "doc/es.1"
    bin.install "es"
    doc.install %w[CHANGES README trip.es examples]
  end

  test do
    system "#{bin}/es < #{doc}/trip.es"
  end
end
