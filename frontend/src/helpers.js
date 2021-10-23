const getTxValue = (level) => {
    switch(level) {
        case "3":
            return "450000000000000000";
        case "4":
            return "1350000000000000000";
        case "5":
            return "4050000000000000000";
        case "6":
            return "12150000000000000000";
        case "7":
            return "36450000000000000000";
        case "8":
            return "109350000000000000000";
        case "2":
        default:
            return "150000000000000000";
    }
}

export default getTxValue;