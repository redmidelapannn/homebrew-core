class Emojify < Formula
  desc "Emoji on the command-line :scream:"
  homepage "https://github.com/mrowa44/emojify"
  url "https://github.com/mrowa44/emojify/archive/v1.0.0.tar.gz"
  sha256 "fabefc4767428a2634a77e7845e315725b75b50f282d0943c5b65789650c25d1"
  head "https://github.com/mrowa44/emojify.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "f433492d9d746e0eb08aa53845d81b931a410c637935064332afac5c74be7f6c" => :el_capitan
    sha256 "444dcb54b73b46945b68f7ae2e14c421dd14686705e7a7b290e9d7633a782ce9" => :yosemite
    sha256 "4a45421d05ff0369b9b8244acbaee31470c840f42979959f828aa43c1c9a537b" => :mavericks
  end

  def install
    bin.install "emojify"
  end

  test do
    assert_equal("Hey, I just 🙋 you, and this is 😱 , but here's my 📲 , so 📞 me, maybe?", shell_output("#{bin}/emojify \"Hey, I just :raising_hand: you, and this is :scream: , but here's my :calling: , so :telephone_receiver: me, maybe?\"").strip)
  end
end
