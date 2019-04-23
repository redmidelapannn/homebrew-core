class Ktlint < Formula
  desc "Anti-bikeshedding Kotlin linter with built-in formatter"
  homepage "https://ktlint.github.io/"
  url "https://github.com/pinterest/ktlint/releases/download/0.32.0/ktlint"
  sha256 "95d292cb45271c733640a3d24add7db4f9f2fac998fb5a15679e6da79fb04441"

  bottle do
    cellar :any_skip_relocation
    sha256 "81a5728bbf0306c4567e3a7b8f6d3fe45d4776bd33b327f7fe0324c6f4e17f4b" => :mojave
    sha256 "81a5728bbf0306c4567e3a7b8f6d3fe45d4776bd33b327f7fe0324c6f4e17f4b" => :high_sierra
    sha256 "46dd348ff3ca90f776b5d30488a756c8462530b2a3f2789a59d85721636e79eb" => :sierra
  end

  def install
    bin.install "ktlint"
  end

  test do
    (testpath/"In.kt").write <<~EOS
      fun main( )
    EOS
    (testpath/"Out.kt").write <<~EOS
      fun main()
    EOS
    system bin/"ktlint", "-F", "In.kt"
    assert_equal shell_output("cat In.kt"), shell_output("cat Out.kt")
  end
end
