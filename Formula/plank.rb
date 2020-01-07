class Plank < Formula
  desc "Framework for generating immutable model objects"
  homepage "https://pinterest.github.io/plank/"
  url "https://github.com/pinterest/plank/archive/v1.5.tar.gz"
  sha256 "bc616c6baa00d66656efb451540bafec2a159047e11037a9e134f4f5fdae7e7b"
  revision 1

  bottle do
    cellar :any_skip_relocation
    sha256 "44ad07cf595184cfbd81c9f98e1e9883cb8091c7329fc1219b964d5bf219d2e8" => :catalina
    sha256 "f1c3e3ddee21f25ebc2145cec987016f0065109a98a2c76695d5be3dff08e680" => :mojave
    sha256 "f1e9844bc435885de955614e4d1265d1f8bca9d698afe0cb5ae51e2cca8be3eb" => :high_sierra
  end

  depends_on :xcode => ["10.1", :build]

  def install
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    (testpath/"pin.json").write <<~EOS
      {
        "id": "pin.json",
        "title": "pin",
        "description" : "Schema definition of a Pin",
        "$schema": "https://json-schema.org/schema#",
        "type": "object",
        "properties": {
          "id": { "type": "string" },
          "link": { "type": "string", "format": "uri"}
         }
      }
    EOS
    system "#{bin}/plank", "--lang", "objc,flow", "--output_dir", testpath, "pin.json"
    assert_predicate testpath/"Pin.h", :exist?, "[ObjC] Generated file does not exist"
    assert_predicate testpath/"PinType.js", :exist?, "[Flow] Generated file does not exist"
  end
end
