class Tokei < Formula
  desc "Program that allows you to count code, quickly"
  homepage "https://github.com/Aaronepower/tokei"
  url "https://github.com/Aaronepower/tokei/archive/v7.0.3.tar.gz"
  sha256 "47848921f7f04fdd1ef515b2db25b931f97471f4b178c7914b3646251bcd8086"

  bottle do
    rebuild 1
    sha256 "f27b501eccc4c08fd1f4c1387fed9d3e093beec1624fea8026ea97b4e43859ce" => :high_sierra
    sha256 "9edb83e7d2c5b0dd82aa2b7f99e4330ddfcdb71f2563aec7ddad1ff1c86ddebc" => :sierra
    sha256 "e10e0a932edd65d6398a34293a65d5a896c88c0fd98dbc947f570bc586bd9599" => :el_capitan
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", "--root", prefix
  end

  test do
    (testpath/"lib.rs").write <<~EOS
      #[cfg(test)]
      mod tests {
          #[test]
          fn test() {
              println!("It works!");
          }
      }
    EOS
    system bin/"tokei", "lib.rs"
  end
end
