const std = @import("std");

fn path(comptime suffix: []const u8) std.Build.LazyPath {
    return .{
        .cwd_relative = comptime ((std.fs.path.dirname(@src().file) orelse ".") ++ suffix),
    };
}

const hal = .{
    .source_file = path("/src/hals/LPC176x5x.zig"),
};

pub const chips = struct {
    pub const lpc176x5x = .{
        .preferred_format = .elf,
        .chip = .{
            // TODO: Separate over those chips, this is not generic!
            .name = "LPC176x5x",
            .cpu = .cortex_m3,
            .memory_regions = &.{
                .{ .offset = 0x00000000, .length = 512 * 1024, .kind = .flash },
                .{ .offset = 0x10000000, .length = 32 * 1024, .kind = .ram },
                .{ .offset = 0x2007C000, .length = 32 * 1024, .kind = .ram },
            },
            .register_definition = .{
                .json = path("/src/chips/LPC176x5x.json"),
            },
        },
        .hal = hal,
    };
};

pub const boards = struct {
    pub const mbed = struct {
        pub const lpc1768 = .{
            .preferred_format = .hex,
            .chip = chips.lpc176x5x.chip,
            .hal = hal,
            .board = .{
                .name = "mbed LPC1768",
                .url = "https://os.mbed.com/platforms/mbed-LPC1768/",
                .source_file = path("/src/boards/mbed_LPC1768.zig"),
            },
        };
    };
};

pub fn build(b: *std.build.Builder) void {
    _ = b;
    // const optimize = b.standardOptimizeOption(.{});
    // inline for (@typeInfo(boards).Struct.decls) |decl| {
    //     if (!decl.is_pub)
    //         continue;

    //     const exe = microzig.addEmbeddedExecutable(b, .{
    //         .name = @field(boards, decl.name).name ++ ".minimal",
    //         .source_file = .{
    //             .path = "test/programs/minimal.zig",
    //         },
    //         .backing = .{ .board = @field(boards, decl.name) },
    //         .optimize = optimize,
    //     });
    //     exe.installArtifact(b);
    // }

    // inline for (@typeInfo(chips).Struct.decls) |decl| {
    //     if (!decl.is_pub)
    //         continue;

    //     const exe = microzig.addEmbeddedExecutable(b, .{
    //         .name = @field(chips, decl.name).name ++ ".minimal",
    //         .source_file = .{
    //             .path = "test/programs/minimal.zig",
    //         },
    //         .backing = .{ .chip = @field(chips, decl.name) },
    //         .optimize = optimize,
    //     });
    //     exe.installArtifact(b);
    // }
}
