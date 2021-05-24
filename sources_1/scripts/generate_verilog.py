def generate_always(signals, stage):
    print("always @ (posedge clk or posedge rst) begin")
    print("    if(rst) begin")
    for signal in signals:
        print(f"        {'_'.join([signal, stage])} <= 0;")
    print("    end else begin")
    for signal in signals:
        print(f"        {'_'.join([signal, stage])} <= {'_'.join([signal, stage, 'wire'])};")
    print("    end")
    print("end")

if __name__ == '__main__':
    import sys
    generate_always(sys.argv[1:], 'IDEX')

