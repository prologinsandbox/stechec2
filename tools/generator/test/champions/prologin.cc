///
// This file has been generated, if you wish to
// modify it in a permanent way, please refer
// to the script file : gen/generator_cxx.rb
//

#include "prologin.hh"

#include <cassert>

///
// Called 10K times to test if things work well.
//
void test()
{
    send_me_42(42);
    send_me_42_and_1337(42, 1337);
    send_me_true(true);
    assert(returns_42() == 42);
    assert(returns_true() == true);

    std::vector<int> r = returns_range(1, 100);
    for (int i = 1; i < 100; ++i)
        assert(r[i - 1] == i);

    r = returns_range(1, 10000);
    for (int i = 1; i < 10000; ++i)
        assert(r[i - 1] == i);

    std::vector<int> v = {1, 3, 2, 4, 5, 7, 6};
    v = sort(v);
    for (int i = 0; i < 7; ++i)
        assert(v[i] == i + 1);

    assert(sort(r) == r);

    struct_with_array s;
    s.field_int = 42;
    for (int i = 0; i < 42; ++i)
    {
        s.field_int_arr.push_back(42);
        simple_struct ss = { 42, true };
        s.field_str_arr.push_back(ss);
    }
    send_me_42s(s);

    send_me_test_enum(VAL1, VAL2);

    std::vector<struct_with_array> l(42);
    for (int i = 0; i < 42; ++i)
    {
        l[i].field_int = 42;
        for (int j = 0; j < 42; ++j)
        {
            l[i].field_int_arr.push_back(42);
            simple_struct ss = { 42, true };
            l[i].field_str_arr.push_back(ss);
        }
    }
    l = send_me_struct_array(l);
    assert(l.size() == 42);
    for (int i = 0; i < 42; ++i)
    {
        assert(l[i].field_int == 42);
        assert(l[i].field_int_arr.size() == 42);
        assert(l[i].field_str_arr.size() == 42);
        for (int j = 0; j < 42; ++j)
        {
            assert(l[i].field_int_arr[j] == 42);
            assert(l[i].field_str_arr[j].field_i == 42);
            assert(l[i].field_str_arr[j].field_bool == true);
        }
    }
}

