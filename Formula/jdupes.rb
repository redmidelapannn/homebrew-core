class Jdupes < Formula
  desc "Duplicate file finder and an enhanced fork of 'fdupes'"
  homepage "https://github.com/jbruchon/jdupes"
  url "https://github.com/jbruchon/jdupes/archive/v1.14.0.tar.gz"
  sha256 "b83285d97f1df5602647749829fdcdbcf21ece273c669bdb8e62544238b1f54e"

  def install
    system "make", "install", "PREFIX=#{prefix}"
  end

  def caveats; <<~EOS
    jdupes is no drop-in replacement for fdupes,
    meaning and availability of options can be different.
  EOS
  end

  test do
    touch "a"
    touch "b"
    (testpath/"c").write("unique file")
    dupes = shell_output("#{bin}/jdupes --zeromatch .").strip.split("\n").sort
    assert_equal ["./a", "./b"], dupes
  end
end
