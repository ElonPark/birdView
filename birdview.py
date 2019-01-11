# -*- coding: UTF-8 -*-


def read_text_file(fileName):
    text = list()

    with open(fileName, "r") as file:
        text = file.readlines()

    return text


def string_to_list(str):
    removeEnter = str.replace('\n', '')

    if ' ' in removeEnter:
        hobbySet = filter(lambda x: x != ' ', removeEnter.split(' '))

        return list(hobbySet)

    return list()

#일치하는 취미 리스트 리턴
def get_intersection(hobbys1, hobbys2):
    intersection = []
    h1 = {}
    h2 = {}

    for hobby in hobbys1:
        h1[hobby] = True

    for hobby in hobbys2:
        if hobby in h1 and hobby not in h2:
            intersection.append(hobby)
            h2[hobby] = True

    return intersection


#대용량 파일 처리용
def matching_couples_with_file(filename):
    coupleDic = {}
    max_match_count = 1

    #커플 목록
    couples = list()

    with open(filename, 'r') as f_outer:
        for i, hobbys1 in enumerate(f_outer):
            with open(filename, 'r') as f_inner:
                for j, hobbys2 in enumerate(f_inner):

                    if i == j:
                        continue

                    is_include_couple = "{}-{}".format(j, i)
                    if is_include_couple in coupleDic:
                        continue

                    h1 = string_to_list(hobbys1)
                    h2 = string_to_list(hobbys2)

                    #공통된 취미만 합침
                    intersection = get_intersection(h1, h2)
                    count = len(intersection)

                    if count > 0:
                        coupleDic["{}-{}".format(i, j)] = True
                        coupleTuple = (i, j, intersection)

                        if count > max_match_count:
                            max_match_count = count
                            couples.insert(0, coupleTuple)

                        else:
                            couples.append(coupleTuple)

    return couples

def matching_couples(value, count):
    coupleDic = {}
    max_match_count = 1

    #커플 목록
    couples = list()
    people = value

    if int(count) > 0:
        people = value[:count]

    for i, hobbys1 in enumerate(people):
        for j, hobbys2 in enumerate(people):
            if i == j:
                continue

            is_include_couple = "{}-{}".format(j, i)
            if is_include_couple in coupleDic:
                continue

            h1 = string_to_list(hobbys1)
            h2 = string_to_list(hobbys2)

            #공통된 취미만 합침
            intersection = get_intersection(h1, h2)
            count = len(intersection)

            if count > 0:
                coupleDic["{}-{}".format(i, j)] = True
                coupleTuple = (i, j, intersection)

                if count > max_match_count:
                    max_match_count = count
                    couples.insert(0, coupleTuple)

                else:
                    couples.append(coupleTuple)

    return couples




def printCouple(maxCount, couples):
    coupleStr = ""

    for i in couples:
        hobbyCount = len(i[2])

        if hobbyCount < maxCount:
            continue

        p1 = i[0] + 1
        p2 = i[1] + 1

        if coupleStr is "":
            coupleStr = "{}-{}".format(p1, p2)
        else:
            #일치하는 취미 갯수가 가장 많은 커플과 동일한 경우
            if hobbyCount == maxCount:
                coupleStr += ", {}-{}".format(p1, p2)

            else:
                break

    print(coupleStr)


def input_mode():
    print("실행모드를 선택하세요. (1: 직접 입력, 2: 버드뷰_500000x10 파일 사용)")

    input_text = input()
    mode = 0

    try:
        mode = int(input_text)
        if mode > 0 or mode < 3:
            return mode

        else:
            print("정상적인 값을 입력하세요.")
            input_mode()

    except:
        print("정상적인 값을 입력하세요.")
        input_mode()


def input_loop(count):
    value = list()

    for _ in range(count):
        value.append(input())

    return value


def self_input_mode():
    print("직접 입력을 선택 하셨습니다. 입력 순서: ")
    print("1. 커플 매칭 대상자 수")
    print("2. 취미 값")

    count = 0

    input_text = input()

    try:
        count = int(input_text)

        if count > 1:
            return input_loop(count)

        else:
            print("2명 이상부터 가능합니다.")
            print("")
            self_input_mode()

    except:
        print("숫자만 입력 가능합니다.")
        self_input_mode()


def read_input_count():
    print("커플 매칭 대상자 수를 입력하세요. (0: 전체)")

    input_text = input()

    try:
        count = int(input_text)

        if count == 0:
            return count

        elif count > 1:
            return count

        else:
            print("2명 이상부터 가능합니다.")
            print("")
            read_input_count()

    except:
        print("숫자만 입력 가능합니다.")
        read_input_count()


def main():
    file = "버드뷰_500000x10.txt"
    count = 0
    value = list()
    couples = list()

    mode = input_mode()

    if mode == 1:
        value = self_input_mode()

        if len(value) < 2:
            print("입력 값이 올바르지 않습니다.")
            main()
        
        #커플 목록
        couples = matching_couples(value, count)

    elif mode == 2:
        count = read_input_count()        
        
        if count == 0:
            couples = matching_couples_with_file(file)

        else: 
            value = read_text_file(file)

            #커플 목록
            couples = matching_couples(value, count)

    couples.sort(key=lambda couple: len(couple[2]), reverse=True)

    #가장 많이 일치하는 취미 갯수
    _, _, hobbys = couples[0]
    maxCount = len(hobbys)

    printCouple(maxCount, couples)


if __name__ == '__main__':
    main()
