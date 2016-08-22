class Zbackup < Formula
  desc "Globally-deduplicating backup tool (based on ideas in rsync)"
  homepage "http://zbackup.org"
  url "https://github.com/zbackup/zbackup/archive/1.4.4.tar.gz"
  sha256 "efccccd2a045da91576c591968374379da1dc4ca2e3dec4d3f8f12628fa29a85"

  bottle do
    cellar :any
    rebuild 1
    sha256 "e80c15a72b793c90068aba6ca8a100ff63f281dabd895887ff0a24ae645051a2" => :el_capitan
    sha256 "9e8e9734b996dd3656595f343ab0e3a3131bbebadf2b9c4f8696dea9f66f1b82" => :yosemite
    sha256 "e4176264fe5cb35787a40d03f556d4dfcfcbd1630fd49918a15ac91dd3188f27" => :mavericks
  end

  depends_on "cmake" => :build
  depends_on "openssl"
  depends_on "protobuf"
  depends_on "xz" # get liblzma compression algorithm library from XZutils
  depends_on "lzo"

  # These fixes are upstream and can be removed in version 1.5+
  patch do
    url "https://github.com/zbackup/zbackup/commit/7e6adda6b1df9c7b955fc06be28fe6ed7d8125a2.diff"
    sha256 "564c494b02be7b159b21f1cfcc963df29350061e050e66b7b3d96ed829552351"
  end

  patch do
    url "https://github.com/zbackup/zbackup/commit/f4ff7bd8ec63b924a49acbf3a4f9cf194148ce18.diff"
    sha256 "47f760aa03a0a1550f05e30b1fa127afa1eda5a802d0d6edd9be07f3762008fb"
  end

  def install
    # Avoid collision with protobuf 3.x CHECK macro
    inreplace ["backup_creator.cc", "check.hh", "chunk_id.cc", "chunk_storage.cc",
      "compression.cc", "encrypted_file.cc", "encryption.cc", "encryption_key.cc", "mt.cc",
      "tests/bundle/test_bundle.cc", "tests/encrypted_file/test_encrypted_file.cc",
      "unbuffered_file.cc", ], /\bCHECK\b/, "ZBCHECK"
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    system "#{bin}/zbackup", "--non-encrypted", "init", "."
    system "echo test | #{bin}/zbackup --non-encrypted backup backups/test.bak"
  end
end
