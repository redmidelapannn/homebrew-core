class Msgpack < Formula
  desc "Library for a binary-based efficient data interchange format"
  homepage "https://msgpack.org/"
  url "https://github.com/msgpack/msgpack-c/releases/download/cpp-2.1.3/msgpack-2.1.3.tar.gz"
  sha256 "beaac1209f33276b5a75e7a02f8689ed44b97209cef82ba0909e06f0c45f6cae"
  head "https://github.com/msgpack/msgpack-c.git"

  bottle do
    rebuild 1
    sha256 "b48a5d40de3d900aec3e43d54011c58dda61c0b53b57efa9f31a5c51cb76dbb5" => :sierra
    sha256 "af7b5ecec807efd5153a381fa61bdb99340633957fb74dda58cd821e62d62624" => :el_capitan
    sha256 "a749bd35bdedf4922c165cbe5596a16b840c6a189a284b49e0b2fc29d814fe99" => :yosemite
  end

  depends_on "cmake" => :build

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    # Reference: http://wiki.msgpack.org/display/MSGPACK/QuickStart+for+C+Language
    (testpath/"test.c").write <<-EOS.undent
      #include <msgpack.h>
      #include <stdio.h>

      int main(void)
      {
         msgpack_sbuffer* buffer = msgpack_sbuffer_new();
         msgpack_packer* pk = msgpack_packer_new(buffer, msgpack_sbuffer_write);
         msgpack_pack_int(pk, 1);
         msgpack_pack_int(pk, 2);
         msgpack_pack_int(pk, 3);

         /* deserializes these objects using msgpack_unpacker. */
         msgpack_unpacker pac;
         msgpack_unpacker_init(&pac, MSGPACK_UNPACKER_INIT_BUFFER_SIZE);

         /* feeds the buffer. */
         msgpack_unpacker_reserve_buffer(&pac, buffer->size);
         memcpy(msgpack_unpacker_buffer(&pac), buffer->data, buffer->size);
         msgpack_unpacker_buffer_consumed(&pac, buffer->size);

         /* now starts streaming deserialization. */
         msgpack_unpacked result;
         msgpack_unpacked_init(&result);

         while(msgpack_unpacker_next(&pac, &result)) {
             msgpack_object_print(stdout, result.data);
             puts("");
         }
      }
    EOS

    system ENV.cc, "-o", "test", "test.c", "-L#{lib}", "-lmsgpackc"
    assert_equal "1\n2\n3\n", `./test`
  end
end
