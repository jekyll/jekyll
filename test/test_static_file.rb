require 'helper'

class TestStaticFile < JekyllUnitTest
    def make_dummy_file(file_name)
        temp_file = File.new(file_name, "w")
        temp_file.puts("some content")
        temp_file.close
    end

    def modify_dummy_file(file_name)
        temp_file = File.open(file_name, "w")
        temp_file.puts("more content")
        temp_file.close
    end

    def remove_dummy_file(file_name)
        File.delete(file_name)
    end

    def setup_static_file(base, dir, name)
        @static_file = StaticFile.new(@site, base, dir, name)
    end

    context "A StaticFile" do
        setup do
            clear_dest
            @site = Site.new(site_configuration)
        end

        should "have a source file path" do
            static_file = setup_static_file("root", "dir", "file_name.html")
            assert_equal "root/dir/file_name.html", static_file.path
        end

        should "have a destination relative directory without a collection" do
            static_file = setup_static_file("root", "dir/subdir", "file.html")
            assert "dir/subdir", static_file.destination_rel_dir 
        end

        should "know its last modification time" do
            file_name = "file.html"
            static_file = setup_static_file(nil, nil, "file.html")
            make_dummy_file(file_name)
            assert_equal Time.new.to_i, static_file.mtime
            remove_dummy_file(file_name)
        end

        should "known if the source path is modified, when it is" do
            file_name = "file_name.txt"
            make_dummy_file(file_name)
            static_file = setup_static_file(nil, nil, file_name)
            sleep 1
            modify_dummy_file(file_name) 
            assert static_file.modified?
            remove_dummy_file(file_name)
        end

        should "known if the source path is modified, when its not" do
            file_name = "file_name.txt"
            make_dummy_file(file_name)
            static_file = setup_static_file(nil, nil, file_name)
            static_file.write(nil)
            sleep 1 # wait, else the times are still the same
            assert !static_file.modified?
            remove_dummy_file(file_name)
        end

        should "known whether to write the file to the filesystem" do
            static_file = setup_static_file("root", "dir", "file_name.txt")
            assert static_file.write?, "always true, with current implementation"
        end

        should "be able to write itself to the desitination direcotry" do
            file_name = "file_name.txt"
            make_dummy_file(file_name)
            static_file = setup_static_file(nil, nil, file_name)
            assert static_file.write(nil)
            remove_dummy_file(file_name)
        end

        should "be able to convert to liquid" do
            file_name = "file_name.txt"
            make_dummy_file(file_name)
            static_file = setup_static_file(nil, nil, "file_name.txt")
            expected = {
                "path"=>"/file_name.txt", 
                "modified_time"=> static_file.mtime.to_s,
                "extname"=>".txt"
            }
            assert expected.eql?(static_file.to_liquid), "map is not the same"
            remove_dummy_file(file_name)
        end
    end
end

