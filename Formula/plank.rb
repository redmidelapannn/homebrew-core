class Plank < Formula
  desc "Framework for generating immutable model objects"
  homepage "https://pinterest.github.io/plank/"
  url "https://github.com/pinterest/plank/archive/v1.4.1.tar.gz"
  sha256 "021889470c1568364fb12e3c704ab98e74c5992749a244a1ef785dd870cad57b"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "c179d7173ea5b92278cfb569bc5100bb65a66f80d0b861e96c4e680083eea45c" => :high_sierra
    sha256 "94f0209d0116048ac0c1d916f3aec0b004e65195e5ff03e8afe00d9f49b98eb7" => :sierra
  end

  depends_on :xcode => ["9.0", :build]

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
